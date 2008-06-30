Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:36664 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYF3O1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 10:27:22 -0400
Received: by py-out-1112.google.com with SMTP id p76so296129pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 07:27:21 -0700 (PDT)
Message-ID: <1ba2fa240806300727k3fe0793cjad6b2bfd313a95b2@mail.gmail.com> (sfid-20080630_162725_980590_75B173A9)
Date: Mon, 30 Jun 2008 17:27:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <20080630135539.GA6864@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
	 <1214817730.5507.27.camel@johannes.berg>
	 <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com>
	 <1214825747.5507.47.camel@johannes.berg>
	 <20080630135539.GA6864@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 4:55 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Jun 30, 2008 at 01:35:47PM +0200, Johannes Berg wrote:
>> On Mon, 2008-06-30 at 14:25 +0300, Tomas Winkler wrote:
>>
>> > The idea was ask troubled user to make change in modprobe.conf and not
>> > changing the code.
>>
>> Yeah but IMHO you're solving the wrong problem. If we want any
>> credibility we shouldn't allow users to ignore any regdom that easily,
>> and this is system-wide.
>
> I share this opinion.  I'm not inclined to merge this patch.

That's okay. I hope Luis will provide better solution for this. And
mostly I hope that everybody agrees  with me that we have a problem
here from the user perspective.
Tomas
