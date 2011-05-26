Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38518 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1EZPJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 11:09:21 -0400
Received: by bwz15 with SMTP id 15so507324bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 08:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDE63B4.4030309@broadcom.com>
References: <4DDE63B4.4030309@broadcom.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 26 May 2011 08:09:00 -0700
Message-ID: <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com> (sfid-20110526_170924_761462_8722D382)
Subject: Re: %d in wlan log messages
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 7:29 AM, Arend van Spriel <arend@broadcom.com> wrote:
> [  563.120590] wlan%d: authenticate with c0:c1:c0:04:b8:2c (try 1)
> [  563.128143] wlan%d: authenticated
> [  563.131517] wlan%d: associate with c0:c1:c0:04:b8:2c (try 1)
> [  563.140933] wlan%d: RX AssocResp from c0:c1:c0:04:b8:2c (capab=0x411
> status=0 aid=4)
> [  563.148714] wlan%d: associated
> [  563.177019] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>
> On latest staging-next I noticed above mentioned log messages. I assume
> these message are from cfg80211 or mac80211. Has this been reported?
>

Interface names [including any numbers] are set by userspace, right?
On my Ubuntu 10.04.2 LTS system, it's
/etc/udev/rules.d/70-persistent.net.rules (or so, this is from
memory). Not a kernel bug.

Dan
