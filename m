Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:7909 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761623AbYGOSAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 14:00:50 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1666858yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 11:00:50 -0700 (PDT)
Message-ID: <1ba2fa240807151100o4865c8fbv10f2ab58916d3739@mail.gmail.com> (sfid-20080715_200115_004961_CA30B6F6)
Date: Tue, 15 Jul 2008 21:00:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Bruno Randolf" <br1@einfach.org>
Subject: Re: [PATCH 3/3] iwlwifi: use generic mac80211 radiotap headers
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <20080715123022.10919.67471.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080715122806.10919.4335.stgit@void>
	 <20080715123022.10919.67471.stgit@void>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 3:30 PM, Bruno Randolf <br1@einfach.org> wrote:
> remove drivers own implementation of radiotap in favor of the generic one
> provided by mac80211.
>
> also remove priv->add_radiotap because it is not used any more.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

ACK
Tomas
