Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48886 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751425AbcKIH2r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 02:28:47 -0500
Message-ID: <1478676523.3313.14.camel@coelho.fi> (sfid-20161109_082850_054594_9B75D8B9)
From: Luca Coelho <luca@coelho.fi>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Date: Wed, 09 Nov 2016 09:28:43 +0200
In-Reply-To: <20161109055033.GA27470@google.com>
References: <20161109055033.GA27470@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 2/3] iwlwifi: mvm: rs: Remove unused 'mcs' variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another nitpick....
On Tue, 2016-11-08 at 21:50 -0800, Kirtika Ruchandani wrote:
> Commit 5fc0f76c4 introduced Rx stats from debugfs, the function
> iwl_mvm_reset_frame_stats from that commit defines and sets mcs but does not use
> it. Compiling iwlwifi with W=1 gives this warning -
> 
> iwlwifi/mvm/rs.c: In function ‘iwl_mvm_update_frame_stats’:
> iwlwifi/mvm/rs.c:3074:14: warning: variable ‘mcs’ set but not used [-Wunused-but-set-variable]
> 
> Fixes: 5fc0f76c43bd (iwlwifi: mvm: add Rx frames statistics via debugfs)

You forgot the quotes here, but no worries, I'll add them.

--
Luca.
