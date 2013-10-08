Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60332 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHU2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 16:28:41 -0400
Received: by mail-ie0-f177.google.com with SMTP id qd12so19687505ieb.8
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 13:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381260511.2081.250.camel@joe-AO722>
References: <20131008184815.3778.52129.stgit@localhost6.localdomain6>
	<1381260511.2081.250.camel@joe-AO722>
Date: Tue, 8 Oct 2013 14:28:40 -0600
Message-ID: <CAErSpo66rdt7F6sem0G0dz7ieRbeJG2P98WNhQBKacF0TWuvFA@mail.gmail.com> (sfid-20131008_222844_393424_E64400DD)
Subject: Re: remove unneeded semicolons
From: Bjorn Helgaas <bhelgaas@google.com>
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, Joe.  I picked up the drivers/pci changes below and will merge
them in the v3.13 merge window if nobody else does it first.

Bjorn


diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index cdc7836..46d1378 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -222,7 +222,7 @@ static long proc_bus_pci_ioctl(struct file *file,
unsigned int cmd,
        default:
                ret = -EINVAL;
                break;
-       };
+       }

        return ret;
 }
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index e1c1ec5..24750a1 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -44,7 +44,7 @@ SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus,
unsigned long, dfn,
        default:
                err = -EINVAL;
                goto error;
-       };
+       }

        err = -EIO;
        if (cfg_ret != PCIBIOS_SUCCESSFUL)
