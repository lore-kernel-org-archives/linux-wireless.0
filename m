Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1A3SLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:11:33 -0500
Received: by iwn9 with SMTP id 9so4705242iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 10:11:32 -0800 (PST)
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [RFC/RFT 0/8] rtl8192cu: Initial upload for comments
Date: Sun, 30 Jan 2011 12:11:32 -0600
Message-Id: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

The following patches will install a new driver (rtl8192cu) for the Realtek
RTL8192CU and the RTL8188CU devices. The material in each of the patches is
as follows:

[1/8]: Add the necessary parts to rtlwifi to support USB devices.
[2-8/8] The source code for the new driver and the changes to rtlwifi's
        Makefile and Kconfig.

The choice of files to be placed in parts 2 through 6 was made to keep
any one patch from being too large. All the patches pass checkpatch and
sparse tests with no errors.

This driver is intended for 2.6.39.



