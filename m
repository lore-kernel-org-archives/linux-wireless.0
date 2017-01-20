Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752331AbdATPwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 10:52:25 -0500
Date: Fri, 20 Jan 2017 16:38:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>
Subject: Re: [PATCH v4 0/3] rt2x00: RT5350 support
Message-ID: <20170120153812.GA23737@redhat.com> (sfid-20170120_165233_257551_FDDB96F2)
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
 <20170120143219.GB22861@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170120143219.GB22861@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Jan 20, 2017 at 03:32:19PM +0100, Daniel Golle wrote:
> On Fri, Jan 20, 2017 at 02:28:23PM +0100, Stanislaw Gruszka wrote:
> > Repost patches from Daniel with updated clock handling and
> > correct author of RT5350 patch.
> > 
> > Note I did not test patches on SOC devices, but getting
> > clock frequency is simple and should be trouble-free.
> 
> Thanks a lot for handling this!
> And big thanks to everyone involved for reviewing a smelly pile of
> patches we had rotting here for half a decade...
> 
> Would you like me to re-work and re-submit the remaining patches needed
> to support RT3883 and RF3853?

Yes, please post them in small sets. 

> Otherwise, the next thing I'd have in mind would be to add device-tree
> bindings to handle in-flash EEPROM loading, see the patches 60[2-9]* in
> https://git.lede-project.org/?p=source.git;a=tree;f=package/kernel/mac80211/patches
> 
> Imho having only support for MTD partitions and skip support for
> requesting firmware files from userspace for now would be the cleanest
> way towards proper WiSoC support in vanilla kernels.
> Obviously our existing patches need to be reworked and stuff needs to
> be added to Documentation/devicetree/bindings.
> Support for non-device-tree legacy platforms which need platform_data
> and legacy EEPROM loading mechanism can remain a local patch in our
> tree until those will no longer be needed.
> Does everybody agree with this general direction?

Sound ok for me.

Thanks
Stanislaw
