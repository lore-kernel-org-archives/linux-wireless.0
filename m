Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0LWQVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 11:21:38 -0500
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Eric Appleman <erappleman@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <loom.20101223T071403-99@post.gmane.org>
References: <loom.20101223T071403-99@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 08:13:07 -0800
Message-ID: <1293120787.3997.50.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 22:15 -0800, Eric Appleman wrote:
> I spent most of the day bisecting and testing numerous kernels and my work has
> finally paid off.
> 
> I've found 2 candidate commits.
> 
> a6866ac93e6cb68091326e80b4fa4619a5957644
> 1402364162afbaac1b8a74ee21aeb013e817ac7d
> 
> iwl3945 definitely broke between 2.6.35-rc2 and -rc3.
> 
> --
For a6866ac93e6cb68091326e80b4fa4619a5957644, did you see any indication
in dmesg for firmware reload?

Wey



