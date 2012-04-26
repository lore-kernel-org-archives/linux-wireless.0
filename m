Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4490 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab2DZMpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 08:45:06 -0400
Message-ID: <4F994349.1040607@broadcom.com> (sfid-20120426_144801_992982_DE90FEAD)
Date: Thu, 26 Apr 2012 14:44:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 04:36 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez"<mcgrof@frijolero.org>
>
> pr_fmt() is either defined or we redefine it. Typically
> drivers define it prior to including printk.h but this
> is done under the assumption that no other subsystem
> it uses has already defined pr_fmt(). In such cases
> pr_fmt() should be undefined and redefined.
>
> Doing this properly shaves down compilation time quite
> considerably.
>
> Signed-off-by: Luis R. Rodriguez<mcgrof@frijolero.org>

Hi Luis,

I actually recall some patches removing inclusion of printk.h sometime 
ago. Not sure what the motivation was, but I will start digging the git 
revision logs.

Gr. AvS


