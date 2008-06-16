Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:27769 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbYFPIJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:09:25 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3446929rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 01:09:24 -0700 (PDT)
Message-ID: <1ba2fa240806160109q751e6990vf9c12e65800fb16a@mail.gmail.com> (sfid-20080616_100939_170843_D430BBA3)
Date: Mon, 16 Jun 2008 11:09:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH] iwl3965: remove useless network and duplicate checking
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 15, 2008 at 9:05 PM, drago01 <drago01@gmail.com> wrote:
> Johannes has posted a similar patch fro iwl4965, I have ported (the
> relevant parts) to iwl3945.
> I tested it and its working fine so far.
> -------------
> mac802 can handle duplicate packages on its own, so let it do it.
> Based on patch from Johannes Berg for iwl4965.

I'm not 100% sure but currently there is missing checking for fragment
duplication in mac80211.
Can someone confirm?
Thanks
Tomas
