Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59218 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0IWUfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 16:35:45 -0400
Received: by gwj17 with SMTP id 17so729598gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 13:35:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9BA6ED.8080304@candelatech.com>
References: <4C9BA6ED.8080304@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Sep 2010 13:35:24 -0700
Message-ID: <AANLkTinY7y7Gf8K518293mdzXh5=42gQ64eUJjJFSaBw@mail.gmail.com>
Subject: Re: Detect if phy is a/b/g/n?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 12:13 PM, Ben Greear <greearb@candelatech.com> wrote:
> Is there a way to determine what a/b/g/n modes a particular phy
> supports?  I tried 'iw phy', but I didn't see anything
> obvious.

'iw list' Rates?

  Luis
