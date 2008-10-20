Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41643 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYJTDkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 23:40:36 -0400
Received: by gxk9 with SMTP id 9so3191387gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 20:40:35 -0700 (PDT)
Message-ID: <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com> (sfid-20081020_054040_755419_6C0118BF)
Date: Sun, 19 Oct 2008 20:40:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224471102.24677.124.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com>
	 <20081015170830.GA15902@tesla>
	 <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
	 <20081015174447.GF15902@tesla>
	 <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
	 <20081015185636.GH15902@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 7:51 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Thu, 2008-10-16 at 04:38 -0700, Luis R. Rodriguez wrote:
>> So.. you didn't look at the code to check where it may have failed...
>
> IIRC, below patch changes the previously allowing none 5GHz channels to
> allowing all 5GHZ channels. It does resolve our problem. But is it the
> correct behaviour? Or did I miss anything?

Well if you are using regulatory_hint() and only have rules defined in
the 2 GHz band then yes it won't ever touch 5 GHz channels... I don't
like this at all but its what I thought you were asking for.

  Luis
