Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:48614 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZBDEFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 23:05:05 -0500
Received: by yx-out-2324.google.com with SMTP id 8so861076yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 20:05:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 23:05:04 -0500
Message-ID: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com> (sfid-20090204_050511_898297_0F47E286)
Subject: at76_usb development
From: Jason Andryuk <jandryuk@gmail.com>
To: gregkh@suse.de, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, oliver@neukum.org, oneukum@suse.de,
	kalle.valo@iki.fi, milan.plzik@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Where should development on at76_usb take place?
staging-at76_usb-mention-mac80211-port-in-todo-file.patch mentions
John Linville's wireless-legacy tree with
revert-staging-at76_usb-update-drivers-staging-at76_usb-w-mac80211-port.patch
reverting mac80211.  wireless-legacy has not been updated since
2.6.27-rc4, but a quick comparison showed that it was more or less
equivalent to what is in wireless-testing/drivers/staging/at76_usb.

I have more or less tracked down an Oops on disconnect with the
wireless-testing version.  Hopefully the time spent has been
worthwhile.

Let me know,

Jason
