Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbXF0M7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 08:59:53 -0400
Subject: Re: libertas warnings on ppc64
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182870019.3703.10.camel@johannes.berg>
References: <1182870019.3703.10.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Jun 2007 09:04:30 -0400
Message-Id: <1182949470.22423.5.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-26 at 17:00 +0200, Johannes Berg wrote:
> drivers/net/wireless/libertas/debugfs.c: In function
> =E2=80=98libertas_getscantable=E2=80=99:
> drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98=
%08llx=E2=80=99
> expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4=
 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98=
%08llx=E2=80=99
> expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4=
 has type =E2=80=98u64=E2=80=99
>=20
> Maybe these were addressed by the current pull request? Thought I'd l=
et
> you know in any case.

Are you using 'upstream-fixes' or 'libertas'?  I just built
'upstream-fixes' Monday on a 64-bit machine and came up with no such
warnings when setting KBUILD_VERBOSE=3D1 before doing the build.

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
