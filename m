Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60055 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbYH1NEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 09:04:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
Date: Thu, 28 Aug 2008 15:04:10 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com> <1219926182.25321.14.camel@johannes.berg> <1ba2fa240808280543qbcb769n74fc8fa733d951a2@mail.gmail.com>
In-Reply-To: <1ba2fa240808280543qbcb769n74fc8fa733d951a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808281504.11364.mb@bu3sch.de> (sfid-20080828_150456_542368_EC830B39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2008, Tomas Winkler wrote:
> >
> > Frankly, this sounds like a "quick, somebody help me come up with a good
> > argument" argument.
> 
> So how can I really reason this :)

<example>
With this patch applied the card will draw about XX Watt less power, so this will
enhance the battery life a lot.
</example>

I'm pretty sure such things are documented in your device specifications.
