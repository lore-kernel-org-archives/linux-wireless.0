Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:47197 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYIRJAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 05:00:39 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1596540eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 02:00:38 -0700 (PDT)
Message-ID: <f488382f0809180200mebef85cxa7051b71e44b673d@mail.gmail.com> (sfid-20080918_110043_672825_30529AE5)
Date: Thu, 18 Sep 2008 02:00:37 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k constantly drops network connection
Cc: "Mats Johannesson" <spamcan1@abrasax.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809180146q2a4062b8hf4e0911d3782c943@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e14212e0809170305v46b0c512i63c1a2874e730274@mail.gmail.com>
	 <20080917191003.GC6198@tesla> <20080918044618.0cd64cd9@loke.fish.not>
	 <20080918103628.5a6ab12c@loke.fish.not>
	 <43e72e890809180146q2a4062b8hf4e0911d3782c943@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 1:46 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Sep 18, 2008 at 1:36 AM, Mats Johannesson <spamcan1@abrasax.se> wrote:
>> Anyhow, writing now to share the good news that the patch you refer to:
>> [PATCH] ath9k: connectivity is lost after Group rekeying is done
>> (Click on [Download message RAW] at
>> http://marc.info/?l=linux-wireless&m=122163541519736&w=2 to get a clean
>> copy) completely fixes the regression between -rc5 and -rc6 I reported
>> in:
>>
>> [ath9k-devel] 2.6.27-rc6 (and forwartd to -rc6-git3) dies silently.
>> https://lists.ath9k.org/pipermail/ath9k-devel/2008-September/000263.html
>>
>> Patching -rc6-git3 I've now run 4 hours without a connection drop.
>> Strangely enough it also allowed me to again make the connection
>> 'sticky' over a reboot (Wicd Manager).
>>
>> This patch is a must have for 2.6.27 no matter what merging policy is
>> in effect.
>
> John please consider merging this for 27 as well as it fixes issues
> reported due to lost of connectivity.
>
>  Luis

Dang! I just developed a pretty much identical patch locally to solve
my wireless connection loss issues and was about 20 minutes into a 5
hour test to make certain it worked correctly. I wish I'd been faster
at getting mine tested and out the door. Oh well, at least -somebody-
got a fix up.

Indeed, please merge this to 2.6.27 ASAP. Having a problem like this
hit the 2.6.27 final release would -really- suck.

- Steven
