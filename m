Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:41072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYFIJUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 05:20:15 -0400
Received: by rv-out-0506.google.com with SMTP id k40so211838rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 02:20:14 -0700 (PDT)
Message-ID: <1ba2fa240806090220y4a21d3d2k84143e2a4ee0cb1a@mail.gmail.com> (sfid-20080609_112019_123738_040C3F27)
Date: Mon, 9 Jun 2008 12:20:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: CONFIG_IWL4965_HT=n in linux-next
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080609015623.6bbc9d88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080609015623.6bbc9d88.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 9, 2008 at 11:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_siso_to_other':
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1439: error: 'struct iwl_priv' has no member named 'current_ht_config'
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1443: error: 'struct iwl_priv' has no member named 'current_ht_config'
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_mimo_to_other':
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1530: error: 'struct iwl_priv' has no member named 'current_ht_config'
> drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1534: error: 'struct iwl_priv' has no member named 'current_ht_config'

It's a known issue. we are about to remove this conditional. Will
happen till EOW.
Tomas
