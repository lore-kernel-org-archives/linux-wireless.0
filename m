Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2K1NkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:40:05 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4478463wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 05:40:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354107229.9345.15.camel@jlt4.sipsolutions.net>
References: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
	<1354036986-30027-1-git-send-email-helmut.schaa@googlemail.com>
	<1354107229.9345.15.camel@jlt4.sipsolutions.net>
Date: Wed, 28 Nov 2012 14:40:03 +0100
Message-ID: <CAGXE3d_eudXndBhiqZUoY80fKNkvteZ6rpEBOYG4Cx6SWZ51Yg@mail.gmail.com> (sfid-20121128_144009_861753_BAAD3955)
Subject: Re: [PATCHv2] mac80211: Reject setting masked mac addresses
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 1:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-11-27 at 18:23 +0100, Helmut Schaa wrote:
>> If a driver registers an address mask we should ensure that no interface
>> gets an address assigned that isn't covered by the registered address
>> mask.
>
> Applied with a few changes, please check.

Yep, looks good. Thanks for fixing up the locking!
Helmut
