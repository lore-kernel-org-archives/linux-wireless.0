Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:42344 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYEUNbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 09:31:23 -0400
Received: by an-out-0708.google.com with SMTP id d40so665875and.103
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 06:31:22 -0700 (PDT)
Message-ID: <43e72e890805210631t7f1f5b32od8e0f67158664f22@mail.gmail.com> (sfid-20080521_153127_930101_FCA2115E)
Date: Wed, 21 May 2008 06:31:21 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Michael Bernhard" <michael.bernhard@bfh.ch>
Subject: Re: [PATCH] compat-2.6: Correct typo
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <12113703302992-git-send-email-michael.bernhard@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <12113703302992-git-send-email-michael.bernhard@bfh.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 4:45 AM, Michael Bernhard
<michael.bernhard@bfh.ch> wrote:
> Signed-off-by: Michael Bernhard <michael.bernhard@bfh.ch>
> ---
> Apparently the compat tree was not compiled with a 2.6.22 Kernel.
> This patch fixes a small typo.

I am Ubuntu hardy now so am mainly testing 2.6.24, glad to see someone
testing 2.6.22. Thanks for the patch, applied, and new tarball pushed
out.

  Luis
