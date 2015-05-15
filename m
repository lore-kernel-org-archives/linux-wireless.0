Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbbEOMzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 08:55:16 -0400
Date: Fri, 15 May 2015 13:54:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rafa?? Mi??ecki <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: ACS support (survey) in few various drives: carl9170, mwifiex,
 mwl8k, p54, rt2800*
Message-ID: <20150515115440.GA20013@redhat.com> (sfid-20150515_145522_824365_55111ADB)
References: <CACna6rw47fBcRczzSjeE1xXdqVPKuwn7yGvbXv2wL8zg8O8pFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACna6rw47fBcRczzSjeE1xXdqVPKuwn7yGvbXv2wL8zg8O8pFA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2015 at 12:59:31PM +0200, Rafa?? Mi??ecki wrote:
> Hi,
> 
> I'm trying to follow ACS implementation in hostapd & kernel. I think I
> managed to document what driver needs to implement to allow hostapd
> use it with acs_survey option:
> https://wireless.wiki.kernel.org/en/users/documentation/acs?&#driver_implementation_details
> 
> All sources say about only 3 drivers supporting ACS: ath5k, ath9k, ath10k.
> 
> However it seems there are more drivers with support for various
> SURVEY_INFO_* stuff. From what I see ACS should work with following
> ones just fine:
> carl9170, mwifiex, mwl8k, p54, rt2800*
> 
> Am I missing something? Is there any reason ACS won't work with above drivers?

On rt2800 get_survey() is not implemented correctly
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2014-December/006751.html

Stanislaw

