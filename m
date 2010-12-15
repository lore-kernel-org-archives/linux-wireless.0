Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0LOShJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 13:37:09 -0500
Received: by iyi12 with SMTP id 12so1035808iyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 10:37:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012151853.10256.br1@einfach.org>
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
 <201012141131.59086.br1@einfach.org> <AANLkTi=6o=tK1fRhOtchT9UPy+EWCcqzhebVYv+8XJP3@mail.gmail.com>
 <201012151853.10256.br1@einfach.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 15 Dec 2010 10:36:48 -0800
Message-ID: <AANLkTim9D+95U2c1DYBOLfTGdgt0pSdQD8ynnZjO0eGY@mail.gmail.com>
Subject: Re: [PATCH 1/2] nl80211: Export available antennas
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 1:53 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Tue December 14 2010 12:11:52 Daniel Halperin wrote:
>> Several of the Intel ones, I believe.  For instance 4965 can RX with 3
>> antennas but can maybe only TX with A and B?  Intel also has a 1x2
>> (5100 maybe?) chipset.
>
> A lot of maybees ;) Can anyone else comment? Do we need available antennas
> separately for RX and TX?
>

Sorry, I thought I had given you enough info to figure it out for
yourself.  Since you're incapable, here's the exact pointer:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-5000.c;h=79ab0a6b138636781482a24bcc35e7da7e21f133;hb=HEAD#l540

That's one instance, there are many others.  Atheros also makes
chipsets like this, and I suspect others do too.

Dan
