Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36124 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbCAWWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 17:22:12 -0500
Received: by widem10 with SMTP id em10so10945399wid.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2015 14:22:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425238304-498-5-git-send-email-emmanuel.grumbach@intel.com>
References: <1425238186.30202.5.camel@egrumbacBox> <1425238304-498-5-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Mar 2015 09:21:51 +1100
Message-ID: <CAGRGNgWgZg83CJh-DH8MVMU9Pkagd5ZwbBKR7ooONVwBgg80Cg@mail.gmail.com> (sfid-20150301_232220_670518_DEA3BB3F)
Subject: Re: [PATCH 05/31] iwlwifi: mvm: consider TDLS queues as used during drain
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Mon, Mar 2, 2015 at 6:31 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Arik Nemtsov <arik@wizery.com>
>
> When a TDLS station is being drained its Tx queues are still in use. Don't
> allocate them to a different station in the meantime.
>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Same here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
