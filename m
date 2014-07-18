Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaGRBtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 21:49:18 -0400
Date: Thu, 17 Jul 2014 18:49:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	James Morris <james.l.morris@oracle.com>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] firmware validation
Message-ID: <20140718014917.GB603@kroah.com> (sfid-20140718_034934_812972_786A38D7)
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2014 at 02:38:10PM -0700, Kees Cook wrote:
> This creates a new LSM hook to validate the contents (and origin) of
> component firmware being provided to the kernel from userspace via the
> request_firmware() interface.
> 
> Additionally creates a test module and test cases for all of the existing
> interfaces as well as the new "fd" interface.

This looks good to me.

I've applied the first 2 patches for now, I'd like to have some other
reviews and acks before applying the rest.

thanks,

greg k-h
