Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:19172 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYBZN3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 08:29:15 -0500
Received: by el-out-1112.google.com with SMTP id v27so1838084ele.23
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 05:29:13 -0800 (PST)
Message-ID: <1ba2fa240802260529g6453a848ka2680ee97afe1cca@mail.gmail.com> (sfid-20080226_132936_635130_241D9C11)
Date: Tue, 26 Feb 2008 15:29:11 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Elyahou ITTAH" <ittah.elyahou@gmail.com>
Subject: Re: Compiler error when compile iwlwifi
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First remedy would be to remove the B43 legacy from compilation
make menuconfig etc
Tomas

On Tue, Feb 26, 2008 at 1:39 PM, Elyahou ITTAH <ittah.elyahou@gmail.com> wrote:
> Hi,
>
>  When i try to compile the iwlwifi driver I have got this error:
>  http://rafb.net/p/UdH56R87.html
>
>  I have a 2.6.24-r2 gentoo kernel,with the iwlwifi included...
>  -
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
