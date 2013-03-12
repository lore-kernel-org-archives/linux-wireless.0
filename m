Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61342 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3CLIbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 04:31:08 -0400
Received: by mail-ie0-f181.google.com with SMTP id 17so6042789iea.12
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 01:31:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513E34FD.8090606@winsoft.pl>
References: <513E34FD.8090606@winsoft.pl>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 12 Mar 2013 08:30:47 +0000
Message-ID: <CAJZjf_zfi3Eph2nnn+qJfGt3wGWJEFGxLuJtXAnb+s-Q9nrzgg@mail.gmail.com> (sfid-20130312_093115_435152_4E8A70D2)
Subject: Re: iwlegacy iwl3945 unable to connect to any hotspots on 3.9.0-rc1/rc2
To: Krzysztof Kolasa <kkolasa@winsoft.pl>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 11, 2013 at 7:48 PM, Krzysztof Kolasa <kkolasa@winsoft.pl> wrote:
> Hotspots are visible and are working OK but wifi card can't connect.
>

Hit this bug also, on the GNOME-3.7.90.iso (based on FC19 testing
ISO), "Can't stop Rx DMA." and friends.

iwl3945 was/is working fine on 3.8.

Krzysztof Kolasa, you may want to see
http://www.spinics.net/lists/linux-wireless/msg104564.html on
requested debugging procedure for the problem.
