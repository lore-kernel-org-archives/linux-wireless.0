Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:50258 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0DGHMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 03:12:23 -0400
Received: by pzk31 with SMTP id 31so740326pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 00:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100407053108.23575.92800.stgit@mj.roinet.com>
References: <20100407053051.23575.94594.stgit@mj.roinet.com>
	<20100407053108.23575.92800.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 7 Apr 2010 00:12:02 -0700
Message-ID: <q2w43e72e891004070012p4867e5e6vfa4386149b65e6c5@mail.gmail.com>
Subject: Re: [PATCH 4/4] compat-wireless: find the actual remote URL
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 6, 2010 at 10:31 PM, Pavel Roskin <proski@gnu.org> wrote:
> Don't assume the remote to be called "origin".  Instead, find the
> current branch first, defaulting to "master".  Then find the
> corresponding remote, defaulting to "origin".  Then find the remote URL,
> defaulting to "unknown".  Reuse the remote URL for TREE_NAME.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks! All 4 patches applied.

  Luis
