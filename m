Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.232]:38546 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYF0PyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:54:09 -0400
Received: by hu-out-0506.google.com with SMTP id 28so1232608hub.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 08:54:06 -0700 (PDT)
Message-ID: <f6ca9fed0806270854u674a9d5aled463865e07829c8@mail.gmail.com> (sfid-20080627_175414_522521_7104D386)
Date: Fri, 27 Jun 2008 17:54:06 +0200
From: drago01 <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2008-06-27
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080627153541.GA16597@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080627153541.GA16597@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 5:35 PM, John W. Linville
<linville@tuxdriver.com> wrote:

> Randy Dunlap (1):
>      iwlwifi: fix build for CONFIG_INPUT=n

this one was NACKED by Ivo (well not exactly this but the 3945
version, and Yi posted an updated patch)
