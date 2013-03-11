Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:54493 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750948Ab3CKUIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 16:08:46 -0400
Date: Mon, 11 Mar 2013 16:08:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
Message-ID: <20130311200831.GB13275@tuxdriver.com> (sfid-20130311_210848_802595_C03794C7)
References: <1363020306-924-1-git-send-email-greearb@candelatech.com>
 <20130311190537.GB32171@tuxdriver.com>
 <513E35CD.3010006@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <513E35CD.3010006@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 11, 2013 at 12:51:41PM -0700, Ben Greear wrote:
> On 03/11/2013 12:05 PM, John W. Linville wrote:
> >On Mon, Mar 11, 2013 at 09:45:06AM -0700, greearb@candelatech.com wrote:
> >>From: Ben Greear <greearb@candelatech.com>
> >>
> >>Otherwise, can't get the Sparklan AR9380 NICs to be
> >>5Ghz APs, since they are in world-roaming domain by
> >>default.  Add this to /etc/modprobe.d/ath9k.conf:
> >>
> >>options ath9k override_eeprom_regdomain=0
> >>
> >>Signed-off-by: Ben Greear <greearb@candelatech.com>
> >
> >Why "=0" to enable it?  Just to make it more confusing?
> 
> You are just setting the country code...and country-code 0 seems
> to at least open up the US regulatory domain so we use it
> by default.
> 
> You can use any country code you wish here.

Ah, sorry -- I brain-locked on it being a logic value...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
