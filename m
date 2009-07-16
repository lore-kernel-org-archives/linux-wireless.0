Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:54294 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbZGPQOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:14:12 -0400
Received: by qw-out-2122.google.com with SMTP id 8so83566qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 09:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bcd1ba70907152058m14249f40gf0ebff1620e56674@mail.gmail.com>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	<1247673740.17896.1983.camel@rc-desk> <1247674310.10754.19.camel@johannes.local>
	<43e72e890907150925p51c1a019r95266cbdc1e762e4@mail.gmail.com>
	<bcd1ba70907152058m14249f40gf0ebff1620e56674@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 09:13:50 -0700
Message-ID: <43e72e890907160913i40c8341fo13b75b38b2700055@mail.gmail.com>
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
To: John Ranson <ranson@analager.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 8:58 PM, John Ranson<ranson@analager.net> wrote:
> The release is master-2009-07-08-3-g3615cdf
>
> /sys/class/ieee80211/ is empty
>
> I'm running Gentoo on an Lenovo R61. I don't think that there is
> anything too special about my configuration.
>
> Is there any more information that I can provide that will help debug?

You can try wireless-testing directly:

http://wireless.kernel.org/en/developers/Documentation/git-guide

  Luis
