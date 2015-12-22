Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15827 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbbLVKBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 05:01:15 -0500
Date: Tue, 22 Dec 2015 11:00:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha Singh <shikha.singh@st.com>
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	raunaque.quaiser@st.com, manoj.kumar@st.com,
	sylvain.fidelis@st.com, patrick.sohn@st.com
Subject: Re: [[linux-nfc] PATCH v1.0 1/1] driver: nfc: st95hf: Fix of build
 error
Message-ID: <20151222100053.GA27181@zurbaran.home> (sfid-20151222_110125_894192_51A573DB)
References: <1450778017-12124-1-git-send-email-shikha.singh@st.com>
 <1450778017-12124-2-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450778017-12124-2-git-send-email-shikha.singh@st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

On Tue, Dec 22, 2015 at 04:53:37AM -0500, Shikha Singh wrote:
> Modification in core.c to rename function "irq_handler"
> and "irq_thread_handler" to "st95hf_irq_handler" and
> "st95hf_irq_thread_handler" respectively. This modification
> was done to remove build error.
> 
> Signed-off-by: Shikha Singh <shikha.singh@st.com>
> ---
>  drivers/nfc/st95hf/core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
