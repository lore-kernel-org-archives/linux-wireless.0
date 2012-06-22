Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62624 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2FVR1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:27:23 -0400
Received: by obbuo13 with SMTP id uo13so2212243obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 10:27:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340385295.4491.38.camel@jlt3.sipsolutions.net>
References: <1340385295.4491.38.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jun 2012 10:27:02 -0700
Message-ID: <CAB=NE6X99pFYfOfAS4exozVtJ=sjujamUanPR_A2aGzX+KziFA@mail.gmail.com> (sfid-20120622_192727_245609_7CF60F73)
Subject: Re: [PATCH] compat-wireless: add patch to fix iwlwifi tracing
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 10:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> See the description in the file -- the current code
> is safe only on recent upstream kernels, with 3.1
> for example it can crash. The new code is safe on
> all kernels that even support %pV, others just get
> a pointer unfortunately.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed!

  Luis
