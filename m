Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41878 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0CRPJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 11:09:33 -0400
Received: by fxm19 with SMTP id 19so2208886fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 08:09:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100318142933.GB4063@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
	 <1268758859.2446.595.camel@rchatre-DESK>
	 <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
	 <20100318142933.GB4063@dhcp-lab-161.englab.brq.redhat.com>
Date: Thu, 18 Mar 2010 16:09:31 +0100
Message-ID: <6cf6b73e1003180809p73da4446v47c9d94b6073c10a@mail.gmail.com>
Subject: Re: [PATCH 2.6.32] iwlwifi: fix nfreed--
From: Adel Gadllah <adel.gadllah@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/18 Stanislaw Gruszka <sgruszka@redhat.com>:
> During backporting of a120e912eb51e347f36c71b60a1d13af74d30e83
> ("iwlwifi: sanity check before counting number of tfds can be free")
> we forget one hunk, what make lot of messages "free more than
> tfds_in_queue" show up in dmesg.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Good catch, that does indeed fix it.

Tested-by: Adel Gadllah <adel.gadllah@gmail.com>
