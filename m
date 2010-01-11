Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:58740 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0AKNpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 08:45:25 -0500
Received: by gxk3 with SMTP id 3so10303283gxk.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 05:45:24 -0800 (PST)
Message-ID: <4B4B2B71.10909@lwfinger.net>
Date: Mon, 11 Jan 2010 07:45:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	mhilzinger@linuxnewmedia.de, Greg Kroah-Hartman <gregkh@suse.de>
Subject: System freezes with rt2860/2870
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo and Gertjan,

The kernel in openSUSE 11.2 was recently upgraded from 2.6.31.5 to 2.6.31.8.
Immediately, users of rt2860/2870 cards began reporting system freezes as soon
as the device makes a wireless connection. For NM users, this is soon after
login. The only recovery is power off. There is at least one bug report at

https://bugzilla.novell.com/show_bug.cgi?id=568446

Do you know any reason for a regression of this nature in the 2.6.31 stable
code? I don't recall any similar complaints on the wireless list, but I don't
always follow the rt2x00 stuff.

Thanks,

Larry

