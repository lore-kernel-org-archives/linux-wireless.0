Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:11699 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYFSIDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 04:03:35 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5037013rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 01:03:34 -0700 (PDT)
Message-ID: <1ba2fa240806190103oe4c8419l132ee9a62bd030b9@mail.gmail.com> (sfid-20080619_100341_331025_2E013D6D)
Date: Thu, 19 Jun 2008 11:03:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwl3965: remove useless network and duplicate checking
Cc: drago01 <drago01@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1213858054.1312.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
	 <1ba2fa240806160109q751e6990vf9c12e65800fb16a@mail.gmail.com>
	 <f6ca9fed0806182313p7f8d5d65u2ef6b5f93e21c394@mail.gmail.com>
	 <1213858054.1312.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-19 at 08:13 +0200, drago01 wrote:
> > On Mon, Jun 16, 2008 at 10:09 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> > > On Sun, Jun 15, 2008 at 9:05 PM, drago01 <drago01@gmail.com> wrote:
> > >> Johannes has posted a similar patch fro iwl4965, I have ported (the
> > >> relevant parts) to iwl3945.
> > >> I tested it and its working fine so far.
> > >> -------------
> > >> mac802 can handle duplicate packages on its own, so let it do it.
> > >> Based on patch from Johannes Berg for iwl4965.
> > >
> > > I'm not 100% sure but currently there is missing checking for fragment
> > > duplication in mac80211.
> > > Can someone confirm?
> >
> > Johannes?
>
> I don't think it is missing since the code checks the full seq_ctrl
> field.
Correct also walidated here, Your patch merge is not the way for 4965.
Tomas
