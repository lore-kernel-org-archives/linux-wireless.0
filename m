Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50618 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab3CTPEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 11:04:45 -0400
Received: by mail-ee0-f43.google.com with SMTP id c50so1099883eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 08:04:44 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Reply-To: isedev@gmail.com
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Date: Wed, 20 Mar 2013 16:04:29 +0100
Message-ID: <2272126.rjuG7RkCA8@wks001.ise.net> (sfid-20130320_160448_859916_5A9F2AED)
In-Reply-To: <5149CD68.7070603@lwfinger.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> <4518745.W5blfs9sIi@wks001.ise.net> <5149CD68.7070603@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 Mar 2013 09:53:28 Larry Finger wrote:
> On 03/20/2013 06:26 AM, ISE Development wrote:
> > Did you get a chance to validate this patch?
> > 
> > So far on my system, it has been running for over week without problems
> > (over 15GB of traffic).
> 
> I have been using the patch, but I am testing rtlwifi drivers quite heavily
> at the moment, thus b43 has had limited usage. In fact, I was waiting to
> get a report from you before pushing the patch. It is ready to go.
> 
> How frequently do you get the automatic reset?
> 
> Larry

At least 3 or 4 per second when exceeding 2Mbit/s, otherwise around 1-2 per 10 
second interval. The card was literally unusable without the patch.

-- 
-- isedev
