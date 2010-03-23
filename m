Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0CWQgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:36:19 -0400
Subject: Re: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e891003230918g2e662957vd9bce29d36f3f334@mail.gmail.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	 <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
	 <43e72e891003230918g2e662957vd9bce29d36f3f334@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 09:35:47 -0700
Message-ID: <1269362147.4263.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 09:18 -0700, Luis R. Rodriguez wrote:

> >        if (changes & BSS_CHANGED_BEACON_INT) {
> >                priv->beacon_int = bss_conf->beacon_int;
> >                /* TODO: in AP mode, do something to make this take effect */
> 
> What happened without this BTW, did it not associate? What AP was it?
> Did you get to test with other drivers by chance?

The thing is that the microcode manages the powersaving, and generates
qos-nullfunc frames which were not understood by some APs.

I'll take another look at the patches asap, but right now I have to do
some planning.

johannes

