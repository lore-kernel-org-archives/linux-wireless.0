Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:51174 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYFSGNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 02:13:16 -0400
Received: by ug-out-1314.google.com with SMTP id h2so915569ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 23:13:15 -0700 (PDT)
Message-ID: <f6ca9fed0806182313p7f8d5d65u2ef6b5f93e21c394@mail.gmail.com> (sfid-20080619_081322_345121_04FA698F)
Date: Thu, 19 Jun 2008 08:13:15 +0200
From: drago01 <drago01@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwl3965: remove useless network and duplicate checking
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240806160109q751e6990vf9c12e65800fb16a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
	 <1ba2fa240806160109q751e6990vf9c12e65800fb16a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 10:09 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Sun, Jun 15, 2008 at 9:05 PM, drago01 <drago01@gmail.com> wrote:
>> Johannes has posted a similar patch fro iwl4965, I have ported (the
>> relevant parts) to iwl3945.
>> I tested it and its working fine so far.
>> -------------
>> mac802 can handle duplicate packages on its own, so let it do it.
>> Based on patch from Johannes Berg for iwl4965.
>
> I'm not 100% sure but currently there is missing checking for fragment
> duplication in mac80211.
> Can someone confirm?

Johannes?
