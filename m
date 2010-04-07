Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39082 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab0DGWME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 18:12:04 -0400
Received: by pva18 with SMTP id 18so1045502pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 15:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100407220810.14021.54998.stgit@mj.roinet.com>
References: <20100407220810.14021.54998.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 7 Apr 2010 15:11:41 -0700
Message-ID: <u2o43e72e891004071511lb929f733m1f29ff20bc424482@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: fix fallbacks for unknown branch, remote
	or remote URL
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 7, 2010 at 3:08 PM, Pavel Roskin <proski@gnu.org> wrote:
> Use bash syntax that yields the replacement value if the variable is
> either empty or unset.  The original code would only check for unset
> variables, but the variable would be set even if git failed to give any
> output to stdout.

thanks applied
