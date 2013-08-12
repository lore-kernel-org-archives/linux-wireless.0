Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63456 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HLXop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:44:45 -0400
Received: by mail-ie0-f176.google.com with SMTP id 9so1891459iec.35
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:44:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <520971BA.6040503@lwfinger.net>
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com>
	<520968B0.80301@lwfinger.net>
	<CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com>
	<520971BA.6040503@lwfinger.net>
Date: Mon, 12 Aug 2013 16:44:45 -0700
Message-ID: <CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com> (sfid-20130813_014448_660166_CB687A6C)
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
From: Colleen Josephson <cjoseph@mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you install the baclports drivers, they will replace the standard ones.

Even for drivers built into my kernel (not as modules?). Just making
sure, as I seem to have encountered a problem:

After installing the backports version of rtl8192ce and rebooting,
wlan0 is not longer showing up when I run "ifconfig".

lsmod shows compat and rtl8192c_common, but not rtl8192ce. If I try
'modprobe rtl8192ce' I get this error: "Unknown symbol in module, or
unknown parameter  (see dmesg)"

dmesg shows "rtlwifi: Unknown symbol mac80211_ieee80211_rx (err 0)"
