Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D1Nf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:35:26 -0400
Date: Wed, 28 Apr 2010 15:33:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't
	give us it's rates
Message-ID: <20100428133336.GA2527@dhcp-lab-161.englab.brq.redhat.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com> <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 28, 2010 at 03:17:04PM +0200, Stanislaw Gruszka wrote:
> If AP do not provide us supported rates before assiociation, send
> all rates we are supporting instead of empty information element.

Please note these two patches together with "QoS fixes":
- mac80211: explicitly disable/enable QoS
- iwlwifi: manage QoS by mac stack
resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=558002

"QoS fixes" alone resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=539878

So I think we want all 4 patches in stable.

John,if possible push patches to Linus tree. When they lend there,
I will post backported patches to stable ML. I have them already
prepared ant tested for 2.6.32 :)

Thanks
Stanislaw
