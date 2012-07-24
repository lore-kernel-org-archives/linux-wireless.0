Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47981 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab2GXV4Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 17:56:24 -0400
Date: Tue, 24 Jul 2012 17:56:17 -0400
From: Pavel Roskin <proski@gnu.org>
To: <Mijzelf@Live.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Uknown symbols in rfkill_backport.ko on 2.6.25.17 on mips
Message-ID: <20120724175617.0a4206c4@mj> (sfid-20120724_235627_925119_A938B600)
In-Reply-To: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan>
References: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 22 Jul 2012 21:11:34 +0200
Mijzelf <Mijzelf@Live.com> wrote:

> I'm trying to get ath9k from compat-wireless-2012-05-08 running on a 
> 2.6.25.17 kernel on mips. The module refuses to load, due to unkown 
> symbols.
> # modprobe ath9k
> modprobe: can't load module rfkill_backport 
> (updates/net/rfkill/rfkill_backport.ko): unknown symbol in module, or 
> unknown parameter
> # dmesg
> rfkill_backport: Unknown symbol input_register_handle
> rfkill_backport: Unknown symbol input_open_device
> rfkill_backport: Unknown symbol input_close_device
> rfkill_backport: Unknown symbol input_unregister_handler
> rfkill_backport: Unknown symbol input_register_handler
> rfkill_backport: Unknown symbol input_unregister_handle
> 
> Any suggestions?

If you can recompile the kernel, enable CONFIG_INPUT in .config

-- 
Regards,
Pavel Roskin
