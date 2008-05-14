Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1812 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbYENEFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 00:05:31 -0400
Subject: Re: newbie rtl8187 question
From: Pavel Roskin <proski@gnu.org>
To: Paul Thomas <pthomas8589@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 00:05:29 -0400
Message-Id: <1210737929.2721.19.camel@rd> (sfid-20080514_060538_165962_E92856F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 20:50 -0700, Paul Thomas wrote:
[private e-mail not quoted]

You can apply patches with patch or with StGIT.  If you haven't used
StGIT before, run "stg init" in the top source directory of the kernel.

stg import -n rtl8187b -u 'https://bugzilla.redhat.com/attachment.cgi?id=304231'
stg import -n rtl8187b-fix -u 'https://bugzilla.redhat.com/attachment.cgi?id=305203'

There will be some warnings about whitespace from StGIT, but the driver
compiles fine, and even sparse doesn't report any warnings.  I'm away
from the adapter, but I assume it would work.

P.S. Please don't take the discussion private.  Others may be interested
in it.

-- 
Regards,
Pavel Roskin
