Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754654AbeDYQgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 12:36:39 -0400
Date: Wed, 25 Apr 2018 18:36:31 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 1/2] firmware: some documentation fixes
Message-ID: <20180425163631.GB30492@kroah.com> (sfid-20180425_183707_035938_FBED799F)
References: <20180425152617.GA5058@kroah.com>
 <20180425162540.11574-1-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180425162540.11574-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2018 at 12:25:39PM -0400, Andres Rodriguez wrote:
> Including:
>  - Fixup outdated kernel-doc paths
>  - Slightly too short title underline
>  - Some typos
> 
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
> 
> Hey Greg,
> 
> Here is the patch rebased on gregkh/driver-core-linus as requested.
> 
> Note that there is a patch by Hans de Goede <hdegoede@redhat.com> that contains
> some of the path fixes as well.
> 
> I also included an extra patch to fix the htmldocs build. I think we are in time
> to squash the fix into the offending commit.

We can't "squash" commits as our trees are not rebasable :)

thanks,

greg k-h
