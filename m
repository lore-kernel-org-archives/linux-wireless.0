Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:55386 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaL3Wft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 17:35:49 -0500
Message-ID: <54A328C2.5080606@lwfinger.net> (sfid-20141230_233552_746873_243271AE)
Date: Tue, 30 Dec 2014 16:35:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"egrumbach@gmail.com" <egrumbach@gmail.com>,
	"peter@hurleysoftware.com" <peter@hurleysoftware.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic>
In-Reply-To: <20141230212326.GA29263@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/30/2014 03:23 PM, Borislav Petkov wrote:
> On Tue, Dec 30, 2014 at 09:41:41PM +0100, Jiri Kosina wrote:
>> If wireless maintainers think otherwise, I'll send a revert request to
>> Linus for consideration.
>
> I wonder if the reaction would be like this one:
>
> https://lkml.org/lkml/2012/12/23/75
>
> :-)

It would be a little like that.

One thread of interest is https://lkml.org/lkml/2014/12/22/348. Commit 
24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable") made it 
impossible to select the IPW2200. The patch to allow selecting the IPW2200, 
which automatically selects CFG80211_WEXT has been added to wireless-drivers, 
but it has not yet made it to mainline. Once it does, then choosing to build the 
IPW2200 will provide a workaround.

In my opinion, the need for the IPW2200 to have CFG80211_WEXT means that the 
original commit will likely be reverted, but your voice will help.

I use openSUSE 13.2, but I control my wireless with NetworkManager. For that 
reason, this is a non-issue for me.

Larry

