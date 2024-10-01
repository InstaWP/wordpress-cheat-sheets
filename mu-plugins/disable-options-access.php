<?php
/**
 * Plugin Name: Disable wp_options Access
 * Description: Prevents access to wp_options via the admin interface
 * Version: 1.0
 * Author: InstaWP
 * Author URI: https://instawp.com
 * License: GPL2
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

class Disable_WP_Options_Access {

    public function __construct() {
        add_action('admin_menu', array($this, 'remove_options_menu'), 999);
        add_action('admin_init', array($this, 'block_options_access'));
    }

    // Remove the Options menu item
    public function remove_options_menu() {
        remove_menu_page('options-general.php');
    }

    // Block access to options pages
    public function block_options_access() {
        global $pagenow;
        $restricted_pages = array(
            'options-general.php',
            'options-writing.php',
            'options-reading.php',
            'options-discussion.php',
            'options-media.php',
            'options-permalink.php',
        );

        if (in_array($pagenow, $restricted_pages)) {
            wp_die('Access to this page has been restricted.', 'Access Denied', array('response' => 403));
        }
    }
}

// Initialize the plugin
new Disable_WP_Options_Access();
