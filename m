Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3IPOM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 10:12:29 -0400
Date: Mon, 16 Sep 2013 16:10:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Ilw] [RFC 0/5] mac80211/iwlwifi: quiesce before restart hw
Message-ID: <20130916141023.GB1411@redhat.com> (sfid-20130916_161233_369607_2B53C2CF)
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DAF383@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DAF383@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 15, 2013 at 08:31:34AM +0000, Grumbach, Emmanuel wrote:
> BTW - I guess a dump_stack doesn't trigger the abrt, does it?

No, dump_stack does not trigger abrt, WARN* or BUG_ON (from process
context) is required for that.

Thanks
Stanislaw
