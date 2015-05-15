Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10119 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030276AbbEONgf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 09:36:35 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Rafa?? Mi??ecki <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 15 May 2015 06:36:20 -0700
Subject: RE: ACS support (survey) in few various drives: carl9170, mwifiex,
 mwl8k, p54, rt2800*
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B171DA596@SC-VEXCH1.marvell.com> (sfid-20150515_153640_190535_A3B27E07)
References: <CACna6rw47fBcRczzSjeE1xXdqVPKuwn7yGvbXv2wL8zg8O8pFA@mail.gmail.com>
 <20150515115440.GA20013@redhat.com>
In-Reply-To: <20150515115440.GA20013@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Stanislaw Gruszka
> Sent: Friday, May 15, 2015 5:25 PM
> To: Rafa?? Mi??ecki
> Cc: linux-wireless@vger.kernel.org; Michal Kazior
> Subject: Re: ACS support (survey) in few various drives: carl9170,
> mwifiex, mwl8k, p54, rt2800*
> 
> On Fri, May 15, 2015 at 12:59:31PM +0200, Rafa?? Mi??ecki wrote:
> > Hi,
> >
> > I'm trying to follow ACS implementation in hostapd & kernel. I think I
> > managed to document what driver needs to implement to allow hostapd
> > use it with acs_survey option:
> > https://wireless.wiki.kernel.org/en/users/documentation/acs?&#driver_i
> > mplementation_details
> >
> > All sources say about only 3 drivers supporting ACS: ath5k, ath9k,
> ath10k.
> >
> > However it seems there are more drivers with support for various
> > SURVEY_INFO_* stuff. From what I see ACS should work with following
> > ones just fine:
> > carl9170, mwifiex, mwl8k, p54, rt2800*
> >
> > Am I missing something? Is there any reason ACS won't work with above
> drivers?
> 
> On rt2800 get_survey() is not implemented correctly
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2
> 014-December/006751.html
> 
> Stanislaw

Mwifiex driver support ACS feature. I think documentation is not updated to reflect this support.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> wireless" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
