Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33824 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbcDMIB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 04:01:28 -0400
Message-ID: <1460534484.3057.2.camel@sipsolutions.net> (sfid-20160413_100131_740803_CFBF6450)
Subject: Re: General VHT rate-ctrl question
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2016 10:01:24 +0200
In-Reply-To: <570D8956.8090806@candelatech.com> (sfid-20160413_014843_049708_B2F53AD9)
References: <570D8956.8090806@candelatech.com>
	 (sfid-20160413_014843_049708_B2F53AD9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-12 at 16:48 -0700, Ben Greear wrote:
> If a station and it's peer can both do VHT, is there ever a good
> reason to even try HT rates?
> 

Not really; perhaps if you could do HT greenfield preamble (which VHT
doesn't have) you could get something out of it, beyond that I don't
see a reason to try.

Unless, for some strange reason, it supports only single stream VHT and
dual-stream HT or something really weird?

johannes
