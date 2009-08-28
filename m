Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:37100 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZH1V1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 17:27:15 -0400
Received: by iwn42 with SMTP id 42so1081449iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 14:27:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251493298.3456.34.camel@johannes.local>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	<1251445557.4189.14.camel@johannes.local> <1251474321.3805.73.camel@rc-desk>
	<1251493298.3456.34.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 28 Aug 2009 14:26:56 -0700
Message-ID: <43e72e890908281426k45d3a07eu8dafa5db12125802@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
	inserted
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2009 at 2:01 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Interesting. I've been thinking about making it go the other way --
> remove rate scaling hooks completely. wl1271 apparently has rate scaling
> completely in the firmware,

Just FYI -- ar9271 seems to also do this in firmware, haven't gotten
to that part yet but so I'm told.

  Luis
