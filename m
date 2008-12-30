Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:22990 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYL3QsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 11:48:23 -0500
Message-ID: <495A50D0.3080000@tuffmail.co.uk> (sfid-20081230_174829_187611_50E7ED71)
Date: Tue, 30 Dec 2008 16:48:16 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <495A1DC8.1050609@tuffmail.co.uk>	 <Pine.LNX.4.44L0.0812301043290.2292-100000@iolanthe.rowland.org> <b6c5339f0812300845y169ee09dwccbc03ff63cf6525@mail.gmail.com>
In-Reply-To: <b6c5339f0812300845y169ee09dwccbc03ff63cf6525@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Tue, Dec 30, 2008 at 10:45 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>   
>>> Is it possible to fix this without suspend support in mac80211?  If not,
>>> I vote we change rtl8187 (and zd_usb) to prevent suspend.  I.e. set USB
>>> suspend callbacks which return an error.
>>>       
>
> Alan J:
>
> Are you using 'echo -n mem > /sys/power/state' directly to do suspend,
> or hitting the power button?

Various.  Normally I use my GUI, which is using s2disk.  I did try using
/sys/power/state directly as well, but there was no difference.
