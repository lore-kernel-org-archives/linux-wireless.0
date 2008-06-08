Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:35838 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYFHQCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 12:02:36 -0400
Received: by an-out-0708.google.com with SMTP id d40so422160and.103
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 09:02:36 -0700 (PDT)
Message-ID: <43e72e890806080902k80272cfk8f34f0740fbbd6d0@mail.gmail.com> (sfid-20080608_180239_805219_EE595A6E)
Date: Sun, 8 Jun 2008 09:02:36 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: Problems with iwl3945 module
Cc: "Cesar Luis Avila" <cavila@fbqf.unt.edu.ar>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8AD95083DC3E36478732061D97524415033FE0B5@pdsmsx411.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4846E57A.9000005@fbqf.unt.edu.ar>
	 <8AD95083DC3E36478732061D97524415033FE0B5@pdsmsx411.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2008 at 7:10 PM, Zhu, Yi <yi.zhu@intel.com> wrote:
>
>
> The HW RF Kill switch is enabled. You have to disable it in some way. It looks like your hotkey Fn-F2 doesn't work. Please take a look at http://rfswitch.sourceforge.net/

Also RFKILL hasn't been ported, I haven't even tested it on compat-wireless.

  Luis
