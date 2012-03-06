Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47524 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 18:47:39 -0500
Received: by iagz16 with SMTP id z16so7761299iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 15:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331076222.28277.2.camel@dfry-linux1>
References: <1331076222.28277.2.camel@dfry-linux1>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 6 Mar 2012 15:47:17 -0800
Message-ID: <CAB=NE6WQ8_LK=4A=qQw3_-a6ebverkKJq-AwtyzegOUU2iXuWA@mail.gmail.com> (sfid-20120307_004743_072825_353576FF)
Subject: Re: [PATCH] compat-wireless: Handle name change from iwlagn to
 iwlwifi in 3.2
To: Don Fry <donald.h.fry@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 6, 2012 at 3:23 PM, Don Fry <donald.h.fry@intel.com> wrote:
> From: Don Fry <donald.h.fry@intel.com>
>
> With linux-3.2 the iwlagn driver is renamed iwlwifi.  For some kernels
> (like 3.1.5) this causes the non-compat iwlagn.ko to try and run against
> the compat mac80211 resulting in an oops.  This change prevents the
> non-compat iwlagn.ko from being loaded.
>
> Signed-off-by: Don Fry <donald.h.fry@intel.com>

Applied and pushed, thanks!

  Luis
