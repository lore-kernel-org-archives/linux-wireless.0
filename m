Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33273 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab1FJNg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 09:36:59 -0400
Date: Fri, 10 Jun 2011 13:39:11 +0000
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
Message-ID: <20110610133911.36f9f8b2@Nokia-N900> (sfid-20110610_153703_169769_31B20E76)
In-Reply-To: <4DF2042C.6060605@broadcom.com>
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
	<BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
	<4DF2042C.6060605@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 10 Jun 2011 13:46:52 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:
> > Michael said we should not do do such a exporting without getting
> > users within the same patch serie.
> That is going to be hard for me despite my willingness to comply. Our 
> driver is still in staging so we submit our brcm80211 patches to Greg 
> KH. I figured it would be better to do submit patches for bcma on 
> wireless repository.

There are no rules without exceptions ;-)


