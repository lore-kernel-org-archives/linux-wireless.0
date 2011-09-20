Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53307 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1ITXvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:51:25 -0400
Received: by bkbzt4 with SMTP id zt4so928759bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 16:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316558247-10018-8-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com> <1316558247-10018-8-git-send-email-wey-yi.w.guy@intel.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 20 Sep 2011 16:51:04 -0700
Message-ID: <CALSq=Ba0-Jryh=cU5bp9MpeTtOAru3YqavuTtwuudjO2_Ri5Ag@mail.gmail.com> (sfid-20110921_015129_113834_C7407CE8)
Subject: Re: [PATCH 7/8] iwlagn: pending frames musn't be incremented if agg
 is on
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 3:37 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
>
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> During my works on the transport layer I removed code that updated
> a local variable (is_agg) that is needed to keep the pending_frames
> count up to date. Fix this.

Seems like a big bug.

Is this a bugfix for a patch earlier in the series or a patch that's
already been accepted. If the former, why not merge? If the latter,
why not CC'ed as a fix to an earlier version of the kernel?

Dan
