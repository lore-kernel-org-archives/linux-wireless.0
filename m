Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbaGURnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 13:43:40 -0400
Date: Mon, 21 Jul 2014 10:43:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	James Morris <james.l.morris@oracle.com>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
Message-ID: <20140721174339.GA16156@kroah.com> (sfid-20140721_194359_792870_FD4EC3DA)
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405373897-31671-5-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2014 at 02:38:14PM -0700, Kees Cook wrote:
> This attaches LSM hooks to the existing firmware loading interfaces:
> filesystem-found firmware and demand-loaded blobs.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

