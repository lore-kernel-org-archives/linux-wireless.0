Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0DATvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 15:51:12 -0400
Received: by pwi5 with SMTP id 5so1358879pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 12:51:12 -0700 (PDT)
Message-ID: <4BB4F92B.4060008@lwfinger.net>
Date: Thu, 01 Apr 2010 14:51:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implement IEEE =?ISO-8859-1?Q?802=2E11=FC?=
References: <201004012059.35748.mb@bu3sch.de>
In-Reply-To: <201004012059.35748.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/2010 01:59 PM, Michael Buesch wrote:
> Hi John,
> 
> This patch implements IEEE 802.11ü. The official standard for German
> extensions to the IEEE 802.11 wireless standard.
> 
> These extensions include:
> * LHSEC (Lederhosen-security): Just barely protects the important parts.
>   Leaves everything else fully exposed to the public, no matter how
>   harmful it is.
> * SAU (Stubborn authentication): The AP won't let you in. No matter what.
>   This is an advanced security feature.
> * BEER (drink-a-lot-of-beer-routing): Will route packets from STAs to randomly
>   chosen APs. It will do this excessively until all APs banned the STA.
> * SRAD (strict radio): This feature will open a popup window for every to be sent
>   packet on the desktop. This window will contain an application form that has
>   to be filled out and sent to the next administration office via snailmail. Upon
>   successful approval by the administration, the packet is officially certified
>   to go "on air" within a well defined timeframe.
>   This is an advanced security feature.

Ahh. Now I begin to understand how the acronyms for the wireless
extensions get selected! Will the selection process for the SRAD
administrators match the one used for Custom's agents at Frankfurt Airport?

Anyone checked the English Google and Gmail main pages today? For those
of you that do not live in Google (i.e. Topeka, Kansas), the Topeka city
council applied for the Google award that will provide free high-speed
broadband connections. To signify their commitment, they renamed their
town Google" for a month.

Larry
