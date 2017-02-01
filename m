Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33793 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbdBAWaE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 17:30:04 -0500
Received: by mail-oi0-f67.google.com with SMTP id w144so31975842oiw.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 14:30:03 -0800 (PST)
Subject: Re: [PATCH 05/11 V2] rtlwifi: btcoexist: Change logging in
 halbtc8192e2ant.c (fwd)
To: Julia Lawall <julia.lawall@lip6.fr>
References: <alpine.DEB.2.20.1702012318350.2021@hadrien>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>, kbuild-all@01.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <58b1b883-9a57-b667-2a7b-b74de24af87a@lwfinger.net> (sfid-20170201_233007_415635_BD0C8DC5)
Date: Wed, 1 Feb 2017 16:30:01 -0600
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702012318350.2021@hadrien>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2017 04:19 PM, Julia Lawall wrote:
> Indeed, there are the four cases where the then and else branches are the
> same.  Is it generated code?
>

I am at least two coding groups removed from the original authors. I have no 
idea how the code was generated. I will fix the problems.

Larry
